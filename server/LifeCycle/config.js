/**
 * Created by f1024 on 25/04/15.
 */
var connectionString = process.env.DATABASE_URL || 'postgres://postgres:passwd123@localhost:5432/lifecycle';

module.exports = connectionString;
