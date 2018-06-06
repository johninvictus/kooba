defmodule KoobaServerWeb.NotifyView do
  use KoobaServerWeb, :view

  alias KoobaServerWeb.NotifyView

  def render("index.json", %{notifications: notifications, pagination: pagination}) do
    %{
      pagination: render_one(pagination, NotifyView, "pagination.json", as: :pagination),
      notifications:
        render_many(notifications, NotifyView, "notification.json", as: :notification)
    }
  end

  def render("notification.json", %{notification: notification}) do
    %{
      id: notification.id,
      message: notification.message,
      json_body: notification.json_body,
      date: Date.to_string(notification.inserted_at)
    }
  end

  def render("pagination.json", %{pagination: pagination}) do
    %{
      page_number: pagination.page_number,
      page_size: pagination.page_size,
      total_entries: pagination.total_entries,
      total_page: pagination.total_pages,
      link:
        "#{KoobaServerWeb.Endpoint.url()}/api/user/notifications?page=#{pagination.page_number}"
    }
  end
end
