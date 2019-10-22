class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create

  end

  def show
    set_header('Custom-Header', "test")
    set_status(201)
    render plain: params[:id]
  end

end
