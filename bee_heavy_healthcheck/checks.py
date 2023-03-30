from datetime import datetime, timedelta
from functools import wraps
from typing import Callable

import botocore
import requests


def check_decorator(func):
    @wraps(func)
    def wrapper(name: str, *args, **kwargs):
        start = datetime.utcnow()
        data = func(name, *args, **kwargs)
        stop = datetime.utcnow()
        data["dur_ms"] = (stop - start) / timedelta(milliseconds=1)
        data["name"] = name
        return data

    return wrapper


def format_check_data(status: str, extra: dict, error_code: str = "", error_message: str = ""):
    if error_code or error_message:
        error = {
            "error": {
                "code": error_code,
                "message": error_message,
            }
        }
    else:
        error = {}

    return {
        "status": status,
        "details": error | extra,
    }


def create_summary(output, total_duration, service_name) -> dict:
    ko_names = [a.get("name") for a in output if a.get("status") == "KO"]
    return {
        "service_status": "KO" if any(ko_names) else "OK",
        "service_name": service_name,
        # "container_id": "?something-that-represents-the-container?",
        "checks_summary": {
            "dur_ms": total_duration / timedelta(milliseconds=1),
            "count": len(output),
            "ko_count": len(ko_names),
            "ko_names": ko_names,
        },
        "checks_details": output,
    }


@check_decorator
def check_options(name, url, headers):
    try:
        resp = requests.options(url, headers=headers, timeout=1)
        resp.raise_for_status()
        data = format_check_data("OK", {"status_code": resp.status_code})
    except requests.ConnectionError as e:
        data = format_check_data("KO", {}, None, str(e))
    except requests.HTTPError as e:
        data = format_check_data("KO", {}, resp.status_code, str(e))
    return data


@check_decorator
def check_s3(name, bucket_sandbox, file_key, s3_client_provider: Callable):
    s3cli = s3_client_provider()
    try:
        s3cli.head_object(Bucket=bucket_sandbox, Key=file_key)
        data = format_check_data("OK", {})
    except botocore.exceptions.ClientError as err:
        data = format_check_data("KO", {}, err.response["Error"]["Code"], str(err))
    return data
