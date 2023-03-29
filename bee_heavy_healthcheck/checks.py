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
