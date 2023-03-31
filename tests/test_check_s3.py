import boto3
import pytest

from bee_heavy_healthcheck.checks import check_s3

pytest.skip("Can't reach S3 bucket.", allow_module_level=True)

S3_BUCKET = "pre-bee-sandbox"


def create_s3_client():
    return boto3.client(
        "s3",
        region_name="eu-west-1",
        aws_access_key_id="XXXXXXXXXXXXXXXXXXX",
        aws_secret_access_key="XXXXXXXXXXXXXXXXXXXX",
        endpoint_url=None,
        verify=None,
    )


def test_check_s3__ko_file():
    output = check_s3("wrong-filename", S3_BUCKET, "wrong_filename.json", create_s3_client)
    assert output["status"] == "KO"


def test_check_s3__ko_bucket():
    output = check_s3(
        "the-important-file",
        "wrong_bucket",
        "the-important-file.json",
        create_s3_client,
    )
    assert output["status"] == "KO"


def test_check_s3__ok():
    output = check_s3("the-important-file", S3_BUCKET, "the-important-file.json", create_s3_client)
    assert output["status"] == "OK"
