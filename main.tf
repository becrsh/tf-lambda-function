provider "aws" {
  region = "eu-central-1"
}

data "aws_iam_policy_document" "assume-role-lambda" {

  statement {
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "lambda-helloworld" {
  assume_role_policy = "${data.aws_iam_policy_document.assume-role-lambda.json}"
  name = "ServiceRole_Lambda-HelloWorld"
}


resource "aws_iam_role_policy_attachment" "lambda-helloworld-basic-execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = "${aws_iam_role.lambda-helloworld.name}"
}

resource "aws_lambda_function" "mylambda" {
  function_name = "HelloWorldLambda"

  filename = "${data.archive_file.helloworld.output_path}"
  source_code_hash = "${data.archive_file.helloworld.output_base64sha256}"
  publish = true

  handler = "index.handler"
  role = "${aws_iam_role.lambda-helloworld.arn}"

  runtime = "nodejs6.10"
  timeout = 15

  tags {
    Terraform = "true"
  }
}

data "archive_file" "helloworld" {
  output_path = "./lambda/out/helloworld.zip"
  type = "zip"
  source_dir = "./lambda/src/helloworld"
}