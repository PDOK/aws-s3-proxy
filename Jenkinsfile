#!/usr/bin/env groovy

properties([
	buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', numToKeepStr: '5')),
	[$class: 'ScannerJobProperty', doNotScan: true]
])

def appVersion = "1.4.${env.BUILD_NUMBER}"

node {
	stage('Checkout') {
		checkout scm
	}

	stage('Build docker image') {
		withEnv([
				"DOCKER_HOST=tcp://inu342.in.kadaster.nl:2376",
				"DOCKER_CERT_PATH=${env.JENKINS_HOME}/.docker/inu342",
				"DOCKER_TLS_VERIFY=1"
		]) {
			docker.withRegistry("http://${env.DOCKER_PROD_URL}") {
				docker.build('pdok/aws-s3-proxy').push(appVersion)
			}
		}
	}
}

timeout(60) {
	stage('Tag as latest') {
		input('Tag this image as latest?')
		node {
			withEnv([
					"DOCKER_HOST=tcp://inu342.in.kadaster.nl:2376",
					"DOCKER_CERT_PATH=${env.JENKINS_HOME}/.docker/inu342",
					"DOCKER_TLS_VERIFY=1"
			]) {
				docker.withRegistry("http://${env.DOCKER_PROD_URL}") {
					docker.image('pdok/aws-s3-proxy').push('latest')
				}
			}
		}
	}
}
