package com.devops.todoapp.repository;

import com.devops.todoapp.model.Todo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Repository pour accéder aux données Todo
 * Spring Data JPA génère automatiquement les méthodes CRUD
 * TP3 DEVOPS - M2 GL
 */
@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {
    // Les méthodes de base (findAll, findById, save, delete) sont automatiques
}
