APP_PATH = "/var/www/courses/"

state_path APP_PATH + "tmp/puma.state"
pidfile APP_PATH + "tmp/pids/puma.pid"

activate_control_app 'unix:///tmp/courses_pumactl.sock'
bind "unix:///tmp/courses_puma.sock"

threads 2, 10

on_restart do
  $redis.quit
end
