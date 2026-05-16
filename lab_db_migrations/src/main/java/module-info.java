module org.example.lab_db_migrations {
    requires javafx.controls;
    requires javafx.fxml;


    opens org.example.lab_db_migrations to javafx.fxml;
    exports org.example.lab_db_migrations;
}