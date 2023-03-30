import boto3
from callee import Float, Regex

from bee_heavy_healthcheck.checks import check_s3

the_file_name = "my-test-tile.txt"
the_bucket = "mybucket"


def create_s3_client():
    return boto3.client(
        "s3",
        region_name="eu-west-1",
        aws_access_key_id="XXXXXXXXXXXX",
        aws_secret_access_key="XXXXXXXXXXXX",
        endpoint_url=None,
        verify=True,
    )


def test_check_unit_s3__ko_file(my_moto):
    output = check_s3("wrong-filename", the_bucket, "wrong_filename.json", create_s3_client)
    assert output == {
        "status": "KO",
        "dur_ms": Float(),
        "details": {
            "error": {
                "code": "404",
                "message": "An error occurred (404) when calling the HeadObject operation: Not Found",
            },
        },
        "name": "wrong-filename",
    }


def test_check_unit_s3__ko_bucket(my_moto):
    output = check_s3("a-check-name", "another-bucket", the_file_name, create_s3_client)
    assert output == {
        "status": "KO",
        "dur_ms": Float(),
        "details": {
            "error": {
                "code": "NoSuchBucket",
                "message": Regex(r".*NoSuchBucket.*"),
            },
        },
        "name": "a-check-name",
    }


def test_check_unit_s3__ok_file(my_moto):
    output = check_s3("a-check-name", the_bucket, the_file_name, create_s3_client)
    assert output == {
        "status": "OK",
        "dur_ms": Float(),
        "details": {},
        "name": "a-check-name",
    }
