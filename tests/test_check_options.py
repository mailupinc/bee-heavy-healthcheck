from unittest import mock

import requests
from callee import Float

from bee_heavy_healthcheck.checks import check_options


@mock.patch("bee_heavy_healthcheck.checks.requests.options")
def test_check_options__ok(mock_options):
    mocked_resp = mock.Mock(status_code=200)
    mocked_resp.elapsed.total_seconds.side_effect = [0.1234]
    mock_options.return_value = mocked_resp

    output = check_options("check-name", "https://test.com", {})

    assert output == {
        "status": "OK",
        "dur_ms": Float(),
        "name": "check-name",
        "details": {"status_code": 200},
    }


@mock.patch(
    "bee_heavy_healthcheck.checks.requests.options",
    side_effect=requests.ConnectionError("exception due to connection error"),
)
def test_check_options__ko(mock):
    output = check_options("check-name", "https://test.com", {})

    assert output == {
        "status": "KO",
        "dur_ms": Float(),
        "name": "check-name",
        "details": {
            "error": {
                "code": None,
                "message": "exception due to connection error",
            },
        },
    }


@mock.patch("bee_heavy_healthcheck.checks.requests.options")
def test_check_options_error__ko(mock_options):
    mocked_resp = mock.Mock(status_code=500)
    mocked_resp.raise_for_status.side_effect = requests.HTTPError(
        "Error message from server", response=mocked_resp
    )
    mock_options.return_value = mocked_resp

    output = check_options("check-name", "https://test.com", {})

    assert output == {
        "status": "KO",
        "dur_ms": Float(),
        "name": "check-name",
        "details": {
            "error": {
                "code": 500,
                "message": "Error message from server",
            },
        },
    }
