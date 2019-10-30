# https://docs.aws.amazon.com/lambda/latest/dg/ruby-package.html
# https://github.com/aws-samples/serverless-sinatra-sample

# https://aws.amazon.com/blogs/compute/announcing-ruby-support-for-aws-lambda/
# https://github.com/aws/aws-sdk-ruby-record

# check-* logic not working:
# .ENVIRONMENT: deploy update delete invoke
# .ROLE: deploy

# Setup:
# modify `.env` file to includes AWS and DYNAMOID variables.
# make image && make install && make install_serverless && make serverless

# Test:
# aws lambda invoke --function-name service-notifications-production-make_request --payload '{"instant":true,"api_key":"___AWS_KEY___","notification":"inline","recipients":[{"uid":1,"email":"__TEST_EMAIL__"}],"objects":{"plain":"hi","html":"\u003cstrong\u003ehello\u003c/strong\u003e"}}' /dev/stdout

check-role:
	ifndef ROLE
	  $(error ROLE is undefined)
	endif

check-env:
	ifndef ENVIRONMENT
	  $(error ENVIRONMENT is undefined)
	endif

check-function:
	ifndef FUNCTION
	  $(error FUNCTION is undefined)
	endif

#
# Docker
#

image:
	docker build -t lambda-ruby2.5 -f Dockerfile.lambda .

shell:
	docker run --rm -it -v $PWD:/var/task -w /var/task lambda-ruby2.5

install:
	docker run --rm -it  -v $$PWD:/var/task -w /var/task lambda-ruby2.5 make _install

test:
	docker run --rm -it -v $$PWD:/var/task -w /var/task --env-file ./.env lambda-ruby2.5 make _test

console:
	docker run --rm -it -e ENVIRONMENT=${ENVIRONMENT} -v $$PWD:/var/task -w /var/task --env-file ./.env lambda-ruby2.5 make _console

install_serverless:
	npm i -g serverless
	npm i -D serverless-dotenv-plugin


# Serverless deploy wires up logging
serverless:
	serverless package --stage production
	serverless deploy --stage production

#
# Prep
#

zip:
	rm -f deploy.zip
	zip -q -r deploy.zip . -x .git/\*

clean:
	rm -rf .bundle/
	rm -rf vendor/

#
# Lamba
#

deploy: #check-env check-role check-function
	aws lambda create-function \
			--region us-east-1 \
			--function-name service-notifications-${ENVIRONMENT}-${FUNCTION} \
			--zip-file fileb://deploy.zip \
			--runtime ruby2.5 \
			--role ${ROLE} \
			--environment Variables="{ENVIRONMENT=${ENVIRONMENT}}" \
			--timeout 20 \
			--handler handler.${FUNCTION}

update: #check-env check-function
	aws lambda update-function-code \
			--region us-east-1 \
			--function-name service-notifications-${ENVIRONMENT}-${FUNCTION} \
			--zip-file fileb://deploy.zip

delete: #check-env check-function
	aws lambda delete-function \
			--region us-east-1 \
			--function-name service-notifications-${ENVIRONMENT}-${FUNCTION}

invoke: #check-env check-function
	aws lambda invoke \
		--region us-east-1 \
		--function-name service-notifications-${ENVIRONMENT}-${FUNCTION} /dev/stdout

#
# Commands that start with underscore are run *inside* the container.
#

_install:
	bundle config
	bundle config --local silence_root_warning true
	AWS=1 bundle install --path vendor/bundle --clean

_test:
	rake spec

_console:
	irb -r 'handler'