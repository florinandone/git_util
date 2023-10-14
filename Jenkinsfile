pipeline {
    agent any

    triggers {
        cron('0 3 * * *')
    }

    stages {
        stage('Clean and Rebase') {
            steps {
                script {
                    // Get the list of subdirectories in the current workspace
                    def subdirectories = sh(script: 'find . -maxdepth 1 -type d -not -name .', returnStdout: true).trim()
                    for (def subdirectory in subdirectories.split('\n')) {
                        def subfolderPath = subdirectory
                        echo "Cleaning and rebasing in subfolder: ${subfolderPath}"
                        // Clean the subfolder
                        sh(script: "../../clean_checkout.sh ${subfolderPath}")
                        // Rebase the subfolder
                        sh(script: "../../rebase_current.sh ${subfolderPath}")
                    }
                }
            }
        }
    }
}
