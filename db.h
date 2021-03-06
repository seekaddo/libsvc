/******************************************************************************
* Copyright (C) 2013 - 2014 Andreas Öman
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************/

#pragma once

#include "queue.h"

#define DB_STORE_RESULT 0x1

#define DB_RESULT_TAG_STR  1
#define DB_RESULT_TAG_INT  2
#define DB_RESULT_TAG_TIME 3

#define DB_RESULT_STRING(x) DB_RESULT_TAG_STR, x, sizeof(x)
#define DB_RESULT_INT(x)    DB_RESULT_TAG_INT, &x
#define DB_RESULT_TIME(x)   DB_RESULT_TAG_TIME, &x


typedef enum {
  DB_ERR_NO_DATA  = 1,
  DB_ERR_OK       = 0,
  DB_ERR_OTHER    = -1,
  DB_ERR_DEADLOCK = -2,
} db_err_t;


typedef struct db_stmt db_stmt_t;
typedef struct db_conn db_conn_t;
typedef struct db_args {
  char type;
  int len;
  union {
    const char *str;
    int i32;
  };
} db_args_t;


db_conn_t *db_get_conn(void);

void db_init(void);

db_stmt_t *db_stmt_get(db_conn_t *c, const char *str);

void db_stmt_reset(db_stmt_t *s);

db_err_t db_stmt_exec(db_stmt_t *s, const char *fmt, ...);

db_err_t db_stmt_execa(db_stmt_t *stmt, int argc, const db_args_t *argv);

int db_stmt_affected_rows(db_stmt_t *s);

int db_stream_row(int flags, db_stmt_t *s, ...)
  __attribute__ ((warn_unused_result));

db_stmt_t *db_stmt_prep(const char *sql);

void db_stmt_cleanup(db_stmt_t **ptr);

#define scoped_db_stmt(x, sql) \
 db_stmt_t *x __attribute__((cleanup(db_stmt_cleanup)))=db_stmt_prep(sql);

db_err_t db_begin(db_conn_t *c)
  __attribute__ ((warn_unused_result));

int db_commit(db_conn_t *c);

int db_rollback(db_conn_t *c);

int db_upgrade_schema(const char *schema_bundle);
