@Library('zweidenker-lib@1.9.0')
import de.zweidenker.*

String repositoryPath = "2denker/active-grid-flutter"
String projectUrl = "https://api.bitbucket.org/2.0/repositories/$repositoryPath"

Bitbucket bitbucket = new Bitbucket(this)
Flutter flutter = new Flutter(this)
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
        label 'ios-build'
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
            archiveArtifacts artifacts: '**/test/failures/*', allowEmptyArchive: true
            throw new Exception("Error in Tests");

          }
        }
        unstable {
          script {
            failedStage = Stage.UnitTest
            archiveArtifacts artifacts: '**/test/failures/*', allowEmptyArchive: true
            throw new Exception("Error in Tests");
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