# DynamoDB
resource "aws_dynamodb_table" "users_table" {
  name = var.table_name

  # 요금제를 선택 고정된 읽기 쓰기가 가능하게 하려면
  # billing_mode를 "PROVISIONED" 로 변경 후, read/write_capacity 활성화
  # 요청당 비용 측정은 billing_mode = "PAY_PER_REQUEST"
  billing_mode = "PAY_PER_REQUEST"

  # read_capacity  = var.read_capacity
  # write_capacity = var.write_capacity

  hash_key  = "UserId"
  range_key = "CreatedAt" # 테이블의 정렬 키로 사용할 속성 추가 (해시 키와 결합)

  attribute {
    name = "UserId"
    type = "S" # String 타입
  }

  attribute {
    name = "CreatedAt"
    type = "S" # 'CreatedAt'은 문자열(String) 타입으로 정렬 키에 사용
  }

  # 글로벌 보조 인덱스 설정 (Global Secondary Index)
  global_secondary_index {
    name            = "UsernameIndex" # 인덱스 이름 설정
    projection_type = "ALL"           # 인덱스에서 모든 테이블 속성을 가져오도록 설정

    # 인덱스의 해시 키로 사용할 속성 (Deprecated)
    # hash_key        = "Username"

    # 인덱스의 해시 키로 사용할 속성
    key_schema {
      attribute_name = "Username"
      key_type       = "HASH"
    }
  }

  attribute {
    name = "Username"
    type = "S" # 'Username'은 문자열(String) 타입으로 보조 인덱스의 해시 키에 사용
  }
}
