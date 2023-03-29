from datetime import timedelta


def format_check_data(
    status: str, extra: dict, error_code: str = "", error_message: str = ""
):
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
