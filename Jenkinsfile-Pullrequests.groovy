@Library('zweidenker-lib@1.9.0')
import de.zweidenker.*

String repositoryPath = "2denker/active-grid-flutter"
String projectUrl = "https://api.bitbucket.org/2.0/repositories/$repositoryPath"

Bitbucket bitbucket = new Bitbucket(this)
Flutter flutter = new Flutter(this)
String targetBranch = null
String bitbucketCredentials = 'git-ac-flutter'
Stage failedStage

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
            failedStage = Stage.Successful
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
          flutter.melosRun('lint:all')
        }
      }
      post {
        failure {
          script {
            failedStage = Stage.Lint
            currentBuild.result = 'UNSTABLE'
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
        junit  skipPublishingChecks: true,  testResults: "**/packages/**/test_results/*.xml"
      }
      post {
        failure {
          script {
            failedStage = Stage.UnitTest
            throw new Exception("Error running tests")

          }
        }
        unstable {
          script {
            if(failedStage != Stage.Lint) {
              failedStage = Stage.UnitTest
              throw new Exception("Error in Tests");
            }
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
        bitbucket.reportPullRequests(projectUrl, failedStage, 'testReport/')
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