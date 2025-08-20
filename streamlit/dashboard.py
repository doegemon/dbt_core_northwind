import streamlit as st


def get_data_postgres():
    """Function to estabilish the connection with the PostgreSQL database."""
    conn = st.connection("postgresql", type="sql")
    return conn


def sales_analysis(connection):
    """Function to create the visuals for the Sales Analysis per country over time."""
    st.subheader("Sales per Country")

    query_sales_country = "SELECT * FROM dbt_mart.orders_per_country_monthly;"

    df_sales_country = connection.query(query_sales_country)

    country_list = df_sales_country["country_code"].unique().tolist()

    country_list.insert(0, "All")

    st.markdown("Select a Country:")
    selected_country = st.selectbox(
        "Select a Country:", country_list, label_visibility="collapsed"
    )

    if selected_country == "All":
        df_filtered_country = df_sales_country.copy()
        df_plot_country = (
            df_filtered_country.groupby("year_month")[["total_orders", "total_revenue"]]
            .sum()
            .reset_index()
        )
    else:
        df_filtered_country = df_sales_country[
            df_sales_country["country_code"] == selected_country
        ]
        df_plot_country = df_filtered_country.copy()

    col1, col2 = st.columns(2)

    with col1:
        st.line_chart(
            data=df_plot_country,
            x="year_month",
            y="total_orders",
            x_label="Period",
            y_label="Total Orders",
        )
    with col2:
        st.line_chart(
            data=df_plot_country,
            x="year_month",
            y="total_revenue",
            x_label="Period",
            y_label="Total Revenue",
        )

    st.write("---")


def product_analysis(connection):
    """Function to create the visuals for the Product Sales Analysis per product category."""
    st.subheader("Sales per Category & Product")

    query_sales_product = "SELECT * FROM dbt_mart.products_rank;"

    df_sales_product = connection.query(query_sales_product)

    categories_list = df_sales_product["category_name"].unique().tolist()

    categories_list.insert(0, "All")

    st.markdown("Select a category:")
    selected_category = st.selectbox(
        "Select a Category:", categories_list, label_visibility="collapsed"
    )

    if selected_category == "All":
        df_filtered_cat = df_sales_product.copy()
    else:
        df_filtered_cat = df_sales_product[
            df_sales_product["category_name"] == selected_category
        ]

    df_top5_orders = df_filtered_cat.sort_values(
        by="total_product_orders", ascending=False
    ).head(5)
    df_top5_revenue = df_filtered_cat.sort_values(
        by="total_product_revenue", ascending=False
    ).head(5)

    col1, col2 = st.columns(2)

    with col1:
        st.subheader(f"Top 5 Products by Number of Orders")
        st.bar_chart(
            data=df_top5_orders,
            x="product_name",
            y="total_product_orders",
            x_label="Product",
            y_label="Orders",
        )

    with col2:
        st.subheader(f"Top 5 Products by GMV")
        st.bar_chart(
            data=df_top5_revenue,
            x="product_name",
            y="total_product_revenue",
            x_label="Product",
            y_label="GMV",
        )

    st.write("---")


def customer_analysis(connection):
    """Function to create the dataframe with the Customers Analysis per country."""
    st.subheader("Customers Details")

    query_customers = "SELECT country_code, customer_id, company_name, first_order_date, last_order_date, total_orders, lifetime_value FROM dbt_mart.customers;"

    df_customers = connection.query(query_customers)

    customer_country_list = df_customers["country_code"].unique().tolist()

    customer_country_list.insert(0, "All")

    st.markdown("Select a country:")
    selected_country_customer = st.selectbox(
        "Select a Country:", customer_country_list, label_visibility="collapsed"
    )

    if selected_country_customer == "All":
        df_filtered_customer = df_customers.copy()
    else:
        df_filtered_customer = df_customers[
            df_customers["country_code"] == selected_country_customer
        ]

    st.dataframe(df_filtered_customer)


if __name__ == "__main__":
    # Page Configuration
    st.set_page_config(page_title="Northwind Dashboard", layout="wide")
    # Header
    st.title("Northwind Dashboard")
    st.markdown(
        "**Dashboard with general information about Sales, Products and Customers of Northwind.**"
    )

    connection = get_data_postgres()
    sales_analysis(connection)
    product_analysis(connection)
    customer_analysis(connection)
