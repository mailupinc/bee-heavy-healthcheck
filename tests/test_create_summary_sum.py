from datetime import timedelta

from bee_heavy_healthcheck.checks import create_summary_with_sum_duration

SERVICE_NAME = "test_service_name"

total_duration = timedelta(seconds=1)


def test_create_summary__one_ko():
    an_output = [
        {"status": "OK", "name": "first_test"},
        {"status": "KO", "name": "second_test"},
        {"name": "third_test"},
    ]
    my_dict = create_summary_with_sum_duration(an_output, SERVICE_NAME)

    assert my_dict == {
        "service_status": "KO",
        "service_name": SERVICE_NAME,
        # "container_id": "?something-that-represents-the-container?",
        "checks_summary": {
            "dur_ms": 0.0,
            "count": 3,
            "ko_count": 1,
            "ko_names": ["second_test"],
        },
        "checks_details": an_output,
    }


def test_create_summary__all_ok():
    an_output = [
        {"status": "OK", "name": "first_test"},
        {"status": "OK", "name": "second_test"},
        {"name": "third_test"},
    ]
    my_dict = create_summary_with_sum_duration(an_output, SERVICE_NAME)
    assert my_dict == {
        "service_status": "OK",
        "service_name": SERVICE_NAME,
        # "container_id": "?something-that-represents-the-container?",
        "checks_summary": {
            "dur_ms": 0.0,
            "count": 3,
            "ko_count": 0,
            "ko_names": [],
        },
        "checks_details": an_output,
    }


def test_create_summary__all_no_status():
    an_output = [
        {"name": "first_test"},
        {"name": "second_test"},
    ]
    my_dict = create_summary_with_sum_duration(an_output, SERVICE_NAME)
    assert my_dict == {
        "service_status": "OK",
        "service_name": SERVICE_NAME,
        # "container_id": "?something-that-represents-the-container?",
        "checks_summary": {
            "dur_ms": 0.0,
            "count": 2,
            "ko_count": 0,
            "ko_names": [],
        },
        "checks_details": an_output,
    }


def test_create_summary__dur_ms():
    an_output = [
        {"status": "OK", "dur_ms": 1.0},
        {"status": "KO", "dur_ms": 10.0},
        {"missing_status": "OK", "dur_ms": 100.5},
        {"status": "KO"},
    ]
    my_dict = create_summary_with_sum_duration(an_output, SERVICE_NAME)
    assert my_dict["checks_summary"]["dur_ms"] == 111.5
