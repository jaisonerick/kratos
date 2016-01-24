url = URI.parse(ENV['REDIS_URL'] ||
                'redis://127.0.0.1:6379')

if Rails.env.test?
  Redis.current = Redis.new(host: url.host, port: url.port,
                            password: url.password, thread_safe: true, db: '15')
else
  Redis.current = Redis.new(host: url.host, port: url.port,
                            password: url.password, thread_safe: true)
end
