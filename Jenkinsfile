pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                checkout scm
                sh 'dotnet build ./Evolution/Evolution.csproj --output ./out'
                stash "${BUILD_NUMBER}"
            }
        }
        stage('Unit Test') {
            steps {
                unstash "${BUILD_NUMBER}"
                sh 'dotnet test ./Evolution.Test.Unit/Evolution.Test.Unit.csproj --filter Category=unit --logger "trx;LogFileName=results\\tests_unit.xml"'
                stash "${BUILD_NUMBER}"
            }
        }
        stage('Integration Test - Oracle') {
            environment {
                String dbName="evolution"
                String oraUser="appUser"
                String oraPwd="appPassword"
                String oraInstance="evolutionDB"
                String oraPort1="6666"
                String oraPort2="6667"
            }
            steps {

                unstash "${BUILD_NUMBER}"
                //Startup Docker container for database
                sh "docker run -d --name ${env.dbName} -p ${env.oraPort1}:1521 -p ${env.oraPort2}:5500 -e ORACLE_SID=${env.oraInstance}	store/oracle/database-enterprise:12.2.0.1"

                timeout(time: 30, unit: 'MINUTES') {
                    sh 'chmod 700 dockerHealth.sh'
                    sh './dockerHealth.sh ${dbName}'
                }

                //Setup test user
                sh "docker cp ./Setup/SetupOracle.sql ${dbName}:SetupOracle.sql"
                retry(5) {
                        sh "docker exec ${dbName} bash -c 'source /home/oracle/.bashrc; sqlplus sys/Oradoc_db1@ORCLCDB as sysdba @/SetupOracle.sql'"
                }
                
                sh "dotnet test ./Evolution.Test.Unit/Evolution.Test.Unit.csproj --filter Category=integration --logger \"trx;LogFileName=results\\tests_integration.xml\""

                //Breakdown container
                sh "docker stop ${env.dbName}"
                sh "docker rm ${env.dbName}"
            }
        }
    }
}