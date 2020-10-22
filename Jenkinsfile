pipeline {
  agent any
  options {
    timeout(time: 2, unit: 'HOURS')
    parallelsAlwaysFailFast()
  }
  environment {
    HOST_JENKINS_HOME = "/var/jenkins_home"
    NFS_ROOT          = '/mnt/fit-hardware-blobs'
    BITSTREAMS_DIR    = "${NFS_ROOT}/bitstreams"
    BUILD_DIR         = "${BRANCH_NAME}-${GIT_COMMIT}"
    TARGET_DIR        = "${BITSTREAMS_DIR}/${BUILD_DIR}"
  }
  stages {
    stage('Get job directory for purging') {
      steps {
        sh('pwd')
      }
    }
    stage('Purge previous builds') {
      steps {
        script {
          def hi = Hudson.instance
          def pname = env.JOB_NAME.split('/')[0]

          hi.getItem(pname).getItem(env.JOB_BASE_NAME).getBuilds().each{ build ->
            def exec = build.getExecutor()

            if (build.number < currentBuild.number && exec != null) {
              exec.interrupt(
                Result.ABORTED,
                new CauseOfInterruption.UserInterruption(
                  "Aborted by #${currentBuild.number}"
                )
              )
              println("Aborted previous running build #${build.number}")
            } else {
              println("Build is not running or is current build, not aborting - #${build.number}")
            }
          }
        }
      }
    }
    stage('Build FIT bitstreams') {
      parallel {
        stage('PM') {
	  steps {
	    sh('./software/ci/build.sh PM')
	  }
	}
        stage('TCM') {
	  steps {
	    sh('./software/ci/build.sh TCM')
	  }
	}
        stage('FTM') {
	  steps {
	    sh('./software/ci/build.sh FTM')
	  }
	}
      }
    }
    stage('Copy bitstreams') {
      steps {
        sh("mkdir -p ${TARGET_DIR}")
	sh("cp firmware/FT0/*/build/*.bit ${TARGET_DIR}")
        sh("cp firmware/FT0/*/build/*.bin ${TARGET_DIR}")
	sh("cp firmware/FT0/*/build/*_logs.tar.gz ${TARGET_DIR}")
      }
    }
    stage('Update latest') {
      when {
        branch 'master'
      }
      steps {
        sh('cd ${BITSTREAMS_DIR} && ln -sfn ${BUILD_DIR} latest && cd -')
      }
    }
  }
}
