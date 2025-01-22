def transform_to_log_format(data):
    log_template = (
        "json USER_ID={user_id} ID={id}"
    )
    return log_template.format(
        user_id=data.get("userId"),
        id=data.get("id")
    )