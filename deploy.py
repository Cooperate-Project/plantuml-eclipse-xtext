import argparse
import base64
import os
import requests

class BintrayAPI:

	def __init__(self, username, apikey, subject, repository, package, version):
		self.username = username
		self.apikey = apikey
		self.subject = subject
		self.repository = repository
		self.package = package
		self.version = version

	def clean(self):
		requestURL = 'https://api.bintray.com/packages/' + self.subject + '/' + self.repository + '/' + self.package + '/versions/' + self.version
		requestHeaders = self.__createAuthorizationHeader({})
		result = requests.get(requestURL, headers=requestHeaders)
		if result.status_code is 200:
			requestURL = 'https://api.bintray.com/packages/' + self.subject + '/' + self.repository + '/' + self.package + '/versions/' + self.version
			result = requests.delete(requestURL, headers=requestHeaders)
			if result.status_code is not 200:
				print('Warning: Could not delete old version ' + self.version)
				print(result.text)
			else:
				print('Deleted old version ' + self.version)

	def uploadFile(self, relativePath, absolutePath, explode=False):
		requestURL = 'https://api.bintray.com/content/' + self.subject + '/' + self.repository + '/' + self.package + '/' + self.version + '/' + self.version + '/' + relativePath
		requestHeaders = self.__createAuthorizationHeader({'X-Bintray-Explode' : ('0', '1')[explode], 'X-Bintray-Publish' : '1', 'X-Bintray-Override' : '1'})
		result = requests.put(requestURL, data=BintrayAPI.__readFileContent(absolutePath), headers=requestHeaders)
		if result.status_code is not 201:
			raise Exception(result.text)
		print('Added new version ' + self.version)

	def __createAuthorizationHeader(self, headers):
		authorizationHeader = { 'Authorization' : 'Basic %s' % base64.b64encode(self.username + ':' + self.apikey) }
		tmp = headers.copy()
		tmp.update(authorizationHeader)
		return tmp;

	@staticmethod
	def __readFileContent(absoluteFilePath):
		with open(absoluteFilePath, 'rb') as f:
					return f.read()



def __parseArguments():
	parser = argparse.ArgumentParser(description='Deploys update site to bintray.')
	parser.add_argument('username', type=str, help='the user name for the deployment on bintray')
	parser.add_argument('apikey', type=str, help='the api key for the deployment on bintray')
	parser.add_argument('subject', type=str, help='the subject/owner of the bintray repository')
	parser.add_argument('repository', type=str, help='the repository to deploy the site on')
	parser.add_argument('package', type=str, help='the package to deploy the site on')
	parser.add_argument('version', type=str, help='the version of the deployed site')
	parser.add_argument('sitezip', type=str, help='the repository zip to be deployed')
	return parser.parse_args()

def main():
	args = __parseArguments()
	bintrayAPI = BintrayAPI(args.username, args.apikey, args.subject, args.repository, args.package, args.version)
	bintrayAPI.clean()
	bintrayAPI.uploadFile(os.path.basename(args.sitezip), args.sitezip, True)

if __name__ == "__main__":
		main()
