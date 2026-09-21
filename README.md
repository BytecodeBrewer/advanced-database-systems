# Advanced Database Systems

University coursework from the **Advanced Database Systems** module at HTWK Leipzig.

This repository is the practical sandbox for the parts of the module that can be made to run: Oracle SQL and PL/SQL, JDBC access from Java, object-relational mapping with JPA, and experiments around concurrency and transactions.

It is coursework, not a polished database framework. Some files are deliberately kept in their original form because preserving the learning trail is more useful than pretending every exercise was born inside a perfect architecture.

## Repository structure

```text
.
├── concurrency/             # Threading and synchronization foundations
├── experiments/             # Database experiments and observations
├── jdbc/                    # Java database access and Oracle driver setup
│   ├── connection/
│   ├── oracle/
│   └── Main.java
├── jpa/                     # JPA / EclipseLink exercise projects
├── lib/                     # Local database driver dependencies
└── sql/
    └── object-types/        # Oracle object types, REF, inheritance, sequences
```

## Topics

- advanced SQL and PL/SQL
- Oracle object types, methods, inheritance, REF, DEREF, TREAT, and sequences
- JDBC connections, queries, prepared statements, and result-set metadata
- persistence and object-relational mapping with JPA
- concurrency, transactions, isolation, and deadlocks

## Technologies

- Oracle Database
- SQL and PL/SQL
- Java
- JDBC
- JPA
- EclipseLink

## Notes

The repository contains selected coursework and experiments rather than every exercise from the module.

Database connection settings refer to the original university environment and must be adjusted before running the code elsewhere. The checked-in `*.class` files and JDBC driver are historical artifacts from the original exercises; future cleanup can replace them with a reproducible build setup.

This repository is the database-specific practice layer. Broader algorithmic and machine-learning experiments will live separately in `data-lab`.
