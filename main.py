from scripts.python import parser
from scripts.python import load_records


if __name__ == "__main__":
    args = parser.parse_args()
    load_records(args)
