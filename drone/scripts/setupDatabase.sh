#!/bin/bash

DB_NAME="DroneDatabase"
DB_USER="DroneUser"
DB_PASS="SecureTheStash"
SQL_ROOT="sudo mysql -u root"

DB_WIFI_TABLE="WifiSignalTable"

setup_database() {
	echo "Setting up database for the drone..."

	$SQL_ROOT <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

	echo "User $DB_USER and database $DB_NAME is set up."
}

setup_table() {
	echo "Ensuring table $DB_WIFI_TABLE is created..."

	mysql -u $DB_USER -p$DB_PASS $DB_NAME <<EOF
CREATE TABLE IF NOT EXISTS $DB_WIFI_TABLE (id INT AUTO_INCREMENT PRIMARY KEY, wifi_name VARCHAR(255), link_quality INTEGER, signal_level INTEGER, seconds_since_epoch INTEGER);
EOF

	echo "Table $DB_WIFI_TABLE is created."
}

insert_row() {
	wifi_name="$1"
	link_quality="$2"
	signal_level="$3"
	seconds_since_epoch=$(date +%s)
	mysql -u $DB_USER -p$DB_PASS $DB_NAME <<EOF
INSERT INTO $DB_WIFI_TABLE (wifi_name, link_quality, signal_level, seconds_since_epoch) VALUES ('$wifi_name', '$link_quality', '$signal_level', '$seconds_since_epoch');
EOF
	echo "Inserted data: wifi: $wifi_name, link quality: $link_quality, signal level: $signal_level, SSE: $seconds_since_epoch."
}

get_all_rows() {
	mysql -u $DB_USER -p$DB_PASS -D $DB_NAME -e "SELECT * FROM $DB_WIFI_TABLE;"
}

setup_database
setup_table
echo "MySQL initialization is complete."
