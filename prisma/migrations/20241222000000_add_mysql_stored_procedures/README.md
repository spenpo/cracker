# MySQL Stored Procedures Migration

This migration adds MySQL stored procedures that replicate the functionality of the original PostgreSQL stored procedures used in the legacy system.

## Stored Procedures Added

### 1. `get_dashboard_metrics(user_id, running_avg)`
Returns dashboard metrics for a user within a specified time range:
- Days of use
- Average creative hours
- Rating distribution (-2, -1, 0, +1, +2)

**Parameters:**
- `user_id` (INT): The user ID
- `running_avg` (VARCHAR): Number of days to look back

**Returns:** Single row with metrics prefixed with underscore (_days_of_use, _avg_hours, etc.)

### 2. `get_dashboard_words(user_id, running_avg, rating_filter, min_hours, max_hours, sort_column, sort_dir)`
Returns word analysis from user tracker entries with filtering and sorting.

**Parameters:**
- `user_id` (INT): The user ID
- `running_avg` (VARCHAR): Number of days to look back
- `rating_filter` (JSON): Array of ratings to filter by (e.g., [1, 2])
- `min_hours` (DECIMAL): Minimum creative hours filter
- `max_hours` (DECIMAL): Maximum creative hours filter
- `sort_column` (VARCHAR): Column to sort by ('word', 'count', 'mentions')
- `sort_dir` (VARCHAR): Sort direction ('asc', 'desc')

**Returns:** Word analysis with count and days used

### 3. `get_dashboard_sentences(user_id, running_avg, rating_filter, min_hours, max_hours, sort_column, sort_dir)`
Returns sentence analysis from user tracker entries with filtering and sorting.

**Parameters:** Same as `get_dashboard_words`

**Returns:** Sentence analysis with tracker metadata

### 4. `get_user_info(user_id)`
Returns user information with their most recent tracker entry.

**Parameters:**
- `user_id` (INT): The user ID

**Returns:** User data with last post information

## Usage in Application

These stored procedures are called from GraphQL resolvers using Prisma's `$queryRaw`:

```typescript
// Example: Call dashboard metrics
const result = await prisma.$queryRaw`
  CALL get_dashboard_metrics(${userId}, ${days})
` as Array<{
  _days_of_use: number
  _avg_hours: number
  _count_neg_two: number
  // ... etc
}>
```

## Migration Instructions

1. Ensure your MySQL database is running
2. Run: `npx prisma migrate deploy` or `npx prisma db push`
3. The stored procedures will be created in your database

## Benefits

- **Performance**: Complex calculations are done in the database
- **Consistency**: Maintains the same functionality as the PostgreSQL version
- **Caching**: Works with existing Redis caching strategy
- **Filtering**: Supports the same filtering options as the original

## Notes

- All stored procedures use MySQL JSON functions for rating filtering
- Date calculations use MySQL's DATE_SUB function
- Temporary tables are used for complex operations and cleaned up automatically
- Error handling is done at the application level in the GraphQL resolvers
