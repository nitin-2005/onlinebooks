package com.bittercode.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

class DatabaseConfig {

    static Properties prop = new Properties();
    static {

        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        InputStream input = classLoader.getResourceAsStream("application.properties");

        try {
            prop.load(input);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static String getEnvOrProp(String envName, String propName) {
        String envValue = System.getenv(envName);
        return (envValue != null && !envValue.trim().isEmpty()) ? envValue : prop.getProperty(propName);
    }

    public final static String DRIVER_NAME = prop.getProperty("db.driver");
    public final static String DB_HOST = getEnvOrProp("MYSQL_HOST", "db.host");
    public final static String DB_PORT = getEnvOrProp("MYSQL_PORT", "db.port");
    public final static String DB_NAME = getEnvOrProp("MYSQL_DATABASE", "db.name");
    public final static String DB_USER_NAME = getEnvOrProp("MYSQL_USER", "db.username");
    public final static String DB_PASSWORD = getEnvOrProp("MYSQL_PASSWORD", "db.password");
    
    // Support complete URL from Env if provided, else construct it
    public final static String CONNECTION_STRING = buildConnectionString();

    private static String buildConnectionString() {
        String envUrl = System.getenv("MYSQL_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            if (envUrl.startsWith("mysql://")) {
                envUrl = envUrl.replaceFirst("mysql://", "jdbc:mysql://");
            }
            return envUrl;
        }
        
        String host = DB_HOST;
        if (!host.startsWith("jdbc:")) {
            if (DRIVER_NAME.contains("mysql")) {
                host = "jdbc:mysql://" + host;
            } else if (DRIVER_NAME.contains("postgresql")) {
                host = "jdbc:postgresql://" + host;
            }
        }
        return host + ":" + DB_PORT + "/" + DB_NAME;
    }

}
