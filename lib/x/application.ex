defmodule X.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      XWeb.Telemetry,
      X.Repo,
      {DNSCluster, query: Application.get_env(:x, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: X.PubSub},
      # Start a worker by calling: X.Worker.start_link(arg)
      # {X.Worker, arg},
      # Start to serve requests, typically the last entry
      XWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: X.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    XWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
