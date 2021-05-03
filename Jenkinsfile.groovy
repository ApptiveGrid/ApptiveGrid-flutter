@Library('zweidenker-lib@feature/AC-461-FlutterActiveGrid-Pipeline')
import de.zweidenker.*

String repositoryPath = "2denker/active-grid-flutter"
String projectUrl = "https://api.bitbucket.org/2.0/repositories/$repositoryPath"

Bitbucket bitbucket = new Bitbucket(this)
Flutter flutter = new Flutter(this)
String bitbucketCredentials = 'git-ac-flutter'
Stage failedStage = Stage.Successful

pipeline {
  agent none

  options { disableConcurrentBuilds() }

  environment {
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
                gitCheckout(bitbucket, null, projectUrl, repositoryPath, bitbucketCredentials)
                env.GIT_COMMIT = getLocalCommit()
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

    stage('Analyze') {
      agent {
        label 'android-build || ios-build'
      }
      steps {
        script {
          try {
            flutter.melosRun('lint:all')
          } catch (Exception e) {
            failedStage = Stage.Lint
            throw e
          }
        }
      }
    }

    stage('Flutter Tests') {
      agent {
        label 'android-build || ios-build'
      }
      steps {
        script {
          flutter.melosRun('test:all')
        }
        junit "**/test_results/*.xml"
      }
      post {
        failure {
          script {
            failedStage = Stage.UnitTest
            throw Exception()

          }
        }
        unstable {
          script {
            failedStage = Stage.UnitTest
            throw Exception()
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
                  try {
                    flutter.melosRun('build:ios')
                  } catch (Exception e) {
                    failedStage = Stage.Assemble
                    throw e
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
                  try {
                    flutter.melosRun('build:android')
                  } catch (Exception e) {
                    failedStage = Stage.Assemble
                    throw e
                  }
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
        if(failedStage == Stage.Successful) {
          currentBuild.result = 'SUCCESS'
          bitbucket.reportBuildResult(projectUrl, BuildState.SUCCESSFUL)
        } else {
          currentBuild.result = 'FAILURE'
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