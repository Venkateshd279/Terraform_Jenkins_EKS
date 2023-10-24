pipeline {
    
    agent any 
    
    environment {
        
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-west-2"
    }
    
    stages {
        
        stage ('Check_out') {
            
            steps {
                
                script {
                    
                    checkout scmGit(branches: [[name: '*/feature/new-code']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Venkateshd279/Terraform_Jenkins_EKS.git']])
                }
            }
            
            
        }
        
        stage ('Intializing Terraform') {
            
            steps {
                
                script {
                    
                    dir('eks') {
                        
                        sh 'terraform init'
                    }
                }
            }
        }
        
        stage ('Formatting Terraform') {
            
            steps {
                
                script {

                    dir('eks') {
                        
                        sh 'terraform fmt'
                    }
                }
            }
        }
        
        stage ('Validate Terraform') {
            
            steps {
                
                script {
                    
                    dir('eks') {
                        
                        sh 'terraform validate'
                    }
                }
            }
        }
        
        stage ('Planning Terraform') {
            
            steps {
                
                script {
                    
                    dir('eks') {
                        
                        sh 'terraform plan'
                    }
                    input(message: "Are you sure to proceed?", ok: "Proceed")
                }
            }
        }
        
        stage ('Applying changes') {
            
            steps {
                
                script {
                    
                    dir('eks') {
                        
                        sh 'terraform $action --auto-approve'
                    }
                }
            }
        }
        
        stage ('Deploy nginx app') {
            
            steps {
                
                script {
                    
                    dir('eks/configuration_files') {
                        
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                    }
                }
            }
        }
    }
}