class TodoitemsController < ApplicationController
  # GET /todoitems
  # GET /todoitems.json
  def index
    @todoitems = Todoitem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @todoitems }
    end
  end

  # GET /todoitems/1
  # GET /todoitems/1.json
  def show
    @todoitem = Todoitem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @todoitem }
    end
  end

  # GET /todoitems/new
  # GET /todoitems/new.json
  def new
    @todoitem = Todoitem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @todoitem }
    end
  end

  # GET /todoitems/1/edit
  def edit
    @todoitem = Todoitem.find(params[:id])
  end

  # POST /todoitems
  # POST /todoitems.json
  def create
    @todoitem = Todoitem.new(params[:todoitem])

    respond_to do |format|
      if @todoitem.save
        format.html { redirect_to @todoitem, notice: 'Todoitem was successfully created.' }
        format.json { render json: @todoitem, status: :created, location: @todoitem }
      else
        format.html { render action: "new" }
        format.json { render json: @todoitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /todoitems/1
  # PUT /todoitems/1.json
  def update
    @todoitem = Todoitem.find(params[:id])

    respond_to do |format|
      if @todoitem.update_attributes(params[:todoitem])
        format.html { redirect_to @todoitem, notice: 'Todoitem was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @todoitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todoitems/1
  # DELETE /todoitems/1.json
  def destroy
    @todoitem = Todoitem.find(params[:id])
    @todoitem.destroy

    respond_to do |format|
      format.html { redirect_to todoitems_url }
      format.json { head :ok }
    end
  end
end
