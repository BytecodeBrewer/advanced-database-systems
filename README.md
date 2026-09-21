# Advanced Database Systems

A practical learning repository for database systems and concurrent programming.

The project started with coursework around Oracle, SQL, JDBC, and JPA and is gradually expanding into concurrency, transaction handling, isolation, and experiments where database behavior and multithreaded code meet.

## Repository structure

```text
.
├── database/
│   ├── jdbc/               # Java database access and Oracle connection exercises
│   ├── jpa/                # Persistence and ORM exercises with JPA / EclipseLink
│   ├── lib/                # Local database dependencies used by older exercises
│   └── sql/
│       └── object-types/   # Oracle object types, REF, inheritance, and sequences
│
├── concurrency/
│   ├── threads/
│   ├── synchronization/
│   ├── producer-consumer/
│   └── thread-pools/
│
└── experiments/
    ├── concurrent-db-access/
    ├── transactions/
    ├── isolation/
    └── deadlocks/
```

## Topics

- relational and object-relational database concepts
- SQL and PL/SQL
- JDBC and database access from Java
- JPA and EclipseLink
- threads and shared state
- synchronization and thread pools
- transactions and isolation
- concurrent database access
- deadlocks and consistency problems

## Technologies

- Oracle Database
- SQL / PL/SQL
- Java
- JDBC
- JPA
- EclipseLink

The repository grows alongside the practical parts of the modules: theory lives elsewhere, code has to earn its place by actually running.
