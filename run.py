import os
from app import create_app
from app.services.db_helper import db

app = create_app()

if __name__ == '__main__':
    # Determine host and port
    host = os.environ.get("FLASK_RUN_HOST", "127.0.0.1")
    port = int(os.environ.get("FLASK_RUN_PORT", 5000))
    debug = os.environ.get("FLASK_DEBUG", "True").lower() == "true"
    
    # Auto-initialize SQLite database if configured and file is missing
    if app.config.get("DB_TYPE") == "sqlite":
        db_path = app.config.get("SQLITE_DB_PATH")
        if db_path and not os.path.exists(db_path):
            print(f"Database file not found at {db_path}. Auto-initializing database...")
            try:
                from app.database.init_db import init_db
                schema_path = os.path.join(
                    os.path.abspath(os.path.dirname(__file__)),
                    "bank_management_system_database.sql"
                )
                init_db(schema_path, db_path)
            except Exception as e:
                print(f"Error auto-initializing database: {e}")

    print(f"Starting Banking Management System on http://{host}:{port}...")
    app.run(host=host, port=port, debug=debug)
