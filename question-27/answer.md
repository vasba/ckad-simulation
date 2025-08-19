# Answer - Question 27 | Labels, Annotations

Based on Question 22 from the Killer Shell exam simulator.

## Problem
Team Sunny needs to identify some of their Pods in namespace sun. They ask you to add a new label `protected: true` to all Pods with an existing label `type: worker` or `type: runner`. Also add an annotation `protected: do not delete this pod` to all Pods having the new label `protected: true`.

## Steps to solve:

1. **First, examine the current pods and their labels**:
```bash
kubectl -n sun get pod --show-labels
```

This will show output similar to:
```
NAME           READY   STATUS    RESTARTS   AGE   LABELS
0509649a       1/1     Running   0          25s   type=runner,type_old=messenger
0509649b       1/1     Running   0          24s   type=worker
1428721e       1/1     Running   0          23s   type=worker
1428721f       1/1     Running   0          22s   type=worker
43b9a          1/1     Running   0          22s   type=test
4c09           1/1     Running   0          21s   type=worker
...
```

2. **Add the `protected=true` label to pods with `type=worker`**:
```bash
kubectl -n sun label pod -l type=worker protected=true
```

3. **Add the `protected=true` label to pods with `type=runner`**:
```bash
kubectl -n sun label pod -l type=runner protected=true
```

**Alternative single command** (more efficient):
```bash
kubectl -n sun label pod -l "type in (worker,runner)" protected=true
```

4. **Verify the labels were added correctly**:
```bash
kubectl -n sun get pod --show-labels
```

Expected output should show `protected=true` added to worker and runner pods:
```
NAME           READY   STATUS    RESTARTS   AGE   LABELS
0509649a       1/1     Running   0          56s   protected=true,type=runner,type_old=messenger
0509649b       1/1     Running   0          55s   protected=true,type=worker
1428721e       1/1     Running   0          54s   protected=true,type=worker
...
43b9a          1/1     Running   0          53s   type=test
5555a          1/1     Running   0          50s   type=messenger
...
```

5. **Add annotation to all pods with `protected=true` label**:
```bash
kubectl -n sun annotate pod -l protected=true protected="do not delete this pod"
```

6. **Verify the annotations were added** (optional):
```bash
kubectl -n sun get pod -l protected=true -o yaml | grep -A 8 metadata:
```

## Key Learning Points:

### Labels:
- **Labels** are key-value pairs attached to objects for identification and selection
- **Label selectors** can be used to filter and operate on groups of objects
- **Multiple label selectors**: Use `-l "key1=value1,key2=value2"` for AND logic
- **Set-based selectors**: Use `-l "key in (value1,value2)"` for OR logic
- **Adding labels**: Use `kubectl label` command with selectors

### Annotations:
- **Annotations** are key-value pairs for storing arbitrary metadata
- **Not used for selection** - cannot use annotations with selectors like labels
- **Useful for**: documentation, tool configuration, build information
- **Adding annotations**: Use `kubectl annotate` command

### Label Selector Examples:
```bash
# Equality-based
kubectl get pods -l type=worker
kubectl get pods -l type!=worker

# Set-based  
kubectl get pods -l "type in (worker,runner)"
kubectl get pods -l "type notin (test,messenger)"

# Multiple conditions (AND)
kubectl get pods -l "type=worker,protected=true"
```

### Command Syntax:
```bash
# Add/modify labels
kubectl label pods <pod-name> <key>=<value>
kubectl label pods -l <selector> <key>=<value>

# Add/modify annotations  
kubectl annotate pods <pod-name> <key>="<value>"
kubectl annotate pods -l <selector> <key>="<value>"

# Remove labels/annotations (use minus sign)
kubectl label pods <pod-name> <key>-
kubectl annotate pods <pod-name> <key>-
```

### Best Practices:
- **Use labels for selection and grouping** of objects
- **Use annotations for metadata** that tools and libraries need
- **Be consistent** with label naming conventions
- **Use namespaces** to avoid naming conflicts
- **Test selectors** before applying bulk operations

## Common Label Selector Patterns:
- **Environment**: `env=prod`, `env=dev`
- **Application**: `app=frontend`, `app=backend`
- **Version**: `version=v1.0`, `version=stable`
- **Component**: `component=database`, `component=api`
