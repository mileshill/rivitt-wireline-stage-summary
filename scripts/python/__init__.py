import argparse
import pathlib
from typing import Generator, Any, List, Tuple

import mysql.connector as mysql
import pandas as pd
from numpy import recarray

from .sql_statements import SQL_DATA, SQL_SHOTS, SQL_STAGES

parser = argparse.ArgumentParser()
parser.add_argument("--db-host", default="localhost", help="MySQL host")
parser.add_argument("--db-user", default="root", help="MySQL user")
parser.add_argument("--db-pass", default="admin", help="MySQL password")
parser.add_argument("--db-database", default="wireline", help="MySQL database")
parser.add_argument("--db-table", required=True, help="MySQL table")
parser.add_argument("--filepath", required=True, help="File to load")


def connect(host: str, user: str, password: str, database: str) -> mysql.MySQLConnection:
    """
    connect opens connection to configured database
    :param host:
    :param user:
    :param password:
    :param database:
    :return:
    """
    return mysql.connect(
        host=host,
        user=user,
        password=password,
        database=database,
        auth_plugin="mysql_native_password"
    )


def load_file(filepath: str) -> List[recarray]:
    assert pathlib.Path(filepath).exists()
    print(f"Loading {filepath}")
    df = pd.read_csv(filepath, low_memory=False).dropna(how="any", axis=0)
    return df.to_records(index=False)


def get_cursor(db: mysql.MySQLConnection) -> mysql.connection.MySQLCursor:
    return db.cursor()


def insert_many(cursor: mysql.connection.MySQLCursor, command: str, values: List[Tuple]) -> Generator[
    mysql.connection.MySQLCursor, Any, None]:
    return cursor.executemany(command, values)


def load_records(args: argparse.Namespace) -> None:
    # Get the correct sql statements
    if args.db_table == "data":
        sql = SQL_DATA
    elif args.db_table == "stages":
        sql = SQL_STAGES
    elif args.db_table == "shots":
        sql = SQL_SHOTS
    else:
        raise Exception("db_table not recognized")

    # Connect to the database
    db = connect(args.db_host, args.db_user, args.db_pass, args.db_database)
    cursor = get_cursor(db)

    # Insert in batches
    records = load_file(args.filepath)
    chunk_size = 500
    for chunk in range(0, len(records), chunk_size):
        # Convert to tuples using np.recarray.tolist()
        batch = [r.tolist() for r in records[chunk: chunk + chunk_size]]
        _ = insert_many(cursor, sql, batch)
    db.commit()
    db.close()
    print(f"Table: {args.db_table}, Num Records Loaded: {len(records)}")
    return
