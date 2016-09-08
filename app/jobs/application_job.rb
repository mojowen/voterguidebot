class ApplicationJob
  def error(job, exception)
    ExceptionNotifier.notify_exception(exception, job: job)
  end
end
