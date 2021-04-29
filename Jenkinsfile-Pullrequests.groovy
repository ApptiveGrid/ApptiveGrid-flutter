@Library('zweidenker-lib@feature/AC-461-FlutterActiveGrid-Pipeline')
import de.zweidenker.*

String repositoryPath = "2denker/active-grid-flutter"
String projectUrl = "https://api.bitbucket.org/2.0/repositories/$repositoryPath"

Bitbucket bitbucket = new Bitbucket(this)
Flutter flutter = new Flutter(this)
String targetBranch = null
String bitbucketCredentials = 'git-ac-flutter'

pipeline {
  agent none

  options { disableConcurrentBuilds() }

  environment {
    PUB_CACHE = "${WORKSPACE}/.pub-cache"
    GRADLE_USER_HOME = "${WORKSPACE}/.gradle"
    FLUTTER_ROOT = "${WORKSPACE}/vendor/flutter"
  }

  stages {
    stage('Setup') {
      matrix {
        axes {
          axis {
            name 'NODE'
            values 'android-build', 'ios-build'
          }
        }
        agent {
          label "$NODE"
        }
        stages {
          stage('Git checkout') {
            steps {
              script {
                targetBranch = bitbucket.pullRequestTargetFor(projectUrl)
                try {
                  gitCheckout(bitbucket, targetBranch, projectUrl, repositoryPath, bitbucketCredentials)
                  env.GIT_COMMIT = getLocalCommit()
                } catch (Exception e) {
                  failedStage = Stage.Merge
                  throw e
                }
              }
            }
          }
          stage('Load Flutter') {
            steps {
              script {
                flutter.install('stable')
              }
            }
          }
          stage('Install Melos') {
            steps {
              script {
                flutter.installMelos()
              }
            }
          }
        }
      }
      post {
        success {
          script {
            bitbucket.startBuildStateReporting(projectUrl)
          }
        }
      }
    }

    stage('Flutter Tests') {
      agent {
        label 'android-build || ios-build'
      }
      steps {
        dir(appDirectory) {
          script {
            flutter.melosRun('test:all')
          }
        }
      }
    }

    stage('Platforms') {
      parallel {
        stage('iOS') {
          agent {
            label 'ios-build'
          }
          stages {
            stage('Build iOS Examples') {
              steps {
                script {
                  flutter.melosRun('build:ios')
                }
              }
              post {
                success {
                  script {
                    archiveArtifacts '**/ios/**/*.ipa'
                  }
                }
              }
            }
          }
        }
        stage('Android') {
          agent {
            label 'android-build'
          }
          stages {
            stage('Build Android Examples') {
              steps {
                script {
                  flutter.melosRun('build:android')
                }
              }
              post {
                success {
                  script {
                    archiveArtifacts '**/release/**/*.apk'
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  post {
    always {
      script {
        if (currentBuild.currentResult == 'SUCCESS') {
          bitbucket.reportBuildResult(projectUrl, BuildState.SUCCESSFUL)
        } else {
          bitbucket.reportBuildResult(projectUrl, BuildState.FAILED)
        }
      }
      node('ios-build') {
        deleteDir()
      }
      node('android-build') {
        deleteDir()
      }
    }
  }
}