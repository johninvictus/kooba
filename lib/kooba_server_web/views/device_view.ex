defmodule KoobaServerWeb.DeviceView do
  use KoobaServerWeb, :view

  alias KoobaServerWeb.DeviceView

  def render("index.json", %{device: device}) do
    %{data: %{device: render_one(device, DeviceView, "device.json")}}
  end

  def render("device.json", %{device: device}) do
    %{
      name: device.name,
      token: device.device_token
    }
  end
end
