import boto3
import pytest
from moto import mock_s3

the_file_name = "my-test-tile.txt"


@pytest.fixture
def my_moto():
    my_moto = mock_s3()
    my_moto.start()

    conn = boto3.resource("s3", region_name="us-east-1")
    conn.create_bucket(Bucket="mybucket")

    conn.meta.client.put_object(Bucket="mybucket", Key=the_file_name, Body="lorem ipsum")

    yield my_moto

    my_moto.stop()
