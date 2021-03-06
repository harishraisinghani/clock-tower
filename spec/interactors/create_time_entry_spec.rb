describe CreateTimeEntry do
  def set_params
    @params = {
      user: @user,
      project_id: @project.try(:id),
      task_id: @task.try(:id),
      duration_in_hours: @duration,
      entry_date: @entry_date.to_s
    }
  end

  before :each do
    @user = create :user
    @project = create :project
    @task = create :task
    @rate = create :rate
    @duration = 1
    @entry_date = Date.today
    set_params
    @time_entry = CreateTimeEntry.call(@params).time_entry
  end

  context "with invalid context" do
    it "should fail if there is no user" do
      @user = nil
      set_params
      result = CreateTimeEntry.call(@params)

      expect(result.success?).to eq(false)
    end

    it "should fail if there is no project id" do
      @project = nil
      set_params
      result = CreateTimeEntry.call(@params)

      expect(result.success?).to eq(false)
    end

    it "should fail if there is no task id" do
      @task = nil
      set_params
      result = CreateTimeEntry.call(@params)

      expect(result.success?).to eq(false)
    end

    it "should fail if there is no duration" do
      @duration = nil
      set_params
      result = CreateTimeEntry.call(@params)

      expect(result.success?).to eq(false)
    end

    it "should set errors if the time entry cannot be created" do
      result = CreateTimeEntry.call(entry_date: Date.today.to_s)
      expect(result.errors).to_not eq(nil)
    end
  end

  it "should create a time entry" do
    expect do
      CreateTimeEntry.call(@params)
    end.to change(TimeEntry, :count).by(1)
  end

  context "with no location on user or project" do
    it "should set the location to nil" do
      expect(@time_entry.location).to be(nil)
    end

    it "should set the holiday code to ca_bc" do
      expect(@time_entry.holiday_code).to eq('ca_bc')
    end
  end

  context "with location on user and not project" do
    before :each do
      @location = create :location, province: 'Quebec'
      @user = create :user, location: @location
      set_params
      @time_entry = CreateTimeEntry.call(@params).time_entry
    end

    it "should set the location to the users location" do
      expect(@time_entry.location).to eq(@location)
    end

    it "should set the holiday code to the locations holiday code" do
      expect(@time_entry.holiday_code).to eq("ca_qc")
    end
  end

  context "with location on project and not user" do
    before :each do
      @location = create :location, province: 'Alberta'
      @project = create :project, location: @location
      set_params
      @time_entry = CreateTimeEntry.call(@params).time_entry
    end

    it "should set the location to the users location" do
      expect(@time_entry.location).to eq(@location)
    end

    it "should set the holiday code to the locations holiday code" do
      expect(@time_entry.holiday_code).to eq("ca_ab")
    end
  end

  context "with location on project and user" do
    before :each do
      @location = create :location, province: 'Nova Scotia'
      @wrong_location = create :location
      @project = create :project, location: @location
      @user = create :user, location: @wrong_location
      set_params
      @time_entry = CreateTimeEntry.call(@params).time_entry
    end

    it "should set the location to the users location" do
      expect(@time_entry.location).to eq(@location)
    end

    it "should set the holiday code to the locations holiday code" do
      expect(@time_entry.holiday_code).to eq("ca_ns")
    end
  end

  describe "holiday" do
    it "should be true if the entry is on a holiday" do
      @entry_date = Date.new(2016, 12, 25)
      set_params
      entry = CreateTimeEntry.call(@params).time_entry
      expect(entry.is_holiday?).to eq(true)
    end

    it "should be false if the entry is not on a holiday" do
      entry = CreateTimeEntry.call(@params).time_entry
      expect(entry.is_holiday?).to eq(false)
    end
  end

  it "should be set to the users holiday rate mutlipler" do
    allow(@user).to receive(:holiday_rate_multiplier).and_return (4.2)
    entry = CreateTimeEntry.call(@params).time_entry
    expect(entry.holiday_rate_multiplier).to eq(4.2)
  end

  describe "tax" do
    it "should set has_tax to the users tax setting" do
      @user = create :user, has_tax: true
      set_params
      entry = CreateTimeEntry.call(@params).time_entry
      expect(entry.has_tax).to eq(true)
    end

    it "should set has_tax to the users tax setting" do
      allow(@user).to receive(:has_tax?).and_return(false)
      entry = CreateTimeEntry.call(@params).time_entry
      expect(entry.has_tax).to eq(false)
    end

    context "with location" do
      before :each do
        @location = create :location, tax_name: 'test', tax_percent: 1.23
        @project = create :project, location: @location
        set_params
        @time_entry = CreateTimeEntry.call(@params).time_entry
      end

      it "should set the tax desc to its locations tax desc" do
        expect(@time_entry.tax_desc).to eq('test')
      end

      it "should set the tax amount to its locations tax amount" do
        expect(@time_entry.tax_percent).to eq(1.23)
      end

    end
  end

  describe "source_rate" do
    it "should not set source_rate if there is no matching rate" do
      set_params
      @time_entry = CreateTimeEntry.call(@params).time_entry
      expect(@time_entry.source_rate).to eq(nil)
    end

    it "should set source_rate if there is a matching rate" do
      r = create :rate, project: @project, task: @task, user: @user, rate: 55
      set_params
      @time_entry = CreateTimeEntry.call(@params).time_entry
      expect(@time_entry.source_rate).to eq(r)
      expect(@time_entry.rate).to eq(r.rate)
    end

  end

  context "with no location" do
    it "should set the tax desc to nil" do
      expect(@time_entry.tax_desc).to eq(nil)
    end

    it "should set the tax percent to nil" do
      expect(@time_entry.tax_percent).to eq(nil)
    end
  end

  describe "rate" do
    context "apply_rate" do
      it "should be eq to the users rate" do
        allow(@user).to receive(:hourly?).and_return (true)
        entry = CreateTimeEntry.call(@params).time_entry
        expect(entry.apply_rate).to eq(true)
      end
      it "should be eq to the users rate" do
        allow(@user).to receive(:hourly?).and_return (false)
        entry = CreateTimeEntry.call(@params).time_entry
        expect(entry.apply_rate).to eq(false)
      end
    end

    context "rate from Rate" do
      it "if Rate exists for Project/Task, use that rate" do
        allow(@user).to receive(:hourly?).and_return (true)
        create :rate, user_id: @user.id, project_id: @project.id, task_id: @task.id, rate: 100
        entry = CreateTimeEntry.call(@params).time_entry
        expect(entry.rate).to eq(100)
      end
    end

    context "not a holiday" do
      before :each do
        allow(@user).to receive(:rate).and_return(10)
        allow(@entry_date).to receive(:holiday?).and_return(false)
      end

      it "should set the rate to the users rate if the task doesn't uses secondary rate" do
        allow(@task).to receive(:apply_secondary_rate?).and_return(false)
        entry = CreateTimeEntry.call(@params).time_entry

        expect(entry.rate).to eq(10)
      end

      it "should set the rate to the users rate if the task doesn't uses secondary rate but the user doesn't have one" do
        allow(@user).to receive(:secondary_rate).and_return(nil)
        @task = create :task, apply_secondary_rate: false
        set_params
        entry = CreateTimeEntry.call(@params).time_entry

        expect(entry.rate).to eq(10)
      end

      it "should set the rate to the users secondary rate if the task uses secondary rate and the user has a secondary rate" do
        @task = create :task, apply_secondary_rate: true
        set_params
        allow(@user).to receive(:secondary_rate).and_return(20)
        entry = CreateTimeEntry.call(@params).time_entry

        expect(entry.rate).to eq(20)
      end
    end

    context "on a holiday" do
      before :each do
        allow(@user).to receive(:rate).and_return(10)
        allow(@user).to receive(:holiday_rate_multiplier).and_return(2)
        @entry_date = Date.new(2016, 12, 25)
        set_params
      end

      it "should set the rate to the users rate * holiday mutlipler if the task doesn't uses secondary rate" do
        allow(@task).to receive(:apply_secondary_rate?).and_return(false)
        entry = CreateTimeEntry.call(@params).time_entry

        expect(entry.rate).to eq(20)
      end

      it "should account for un-even rate" do
        allow(@user).to receive(:holiday_rate_multiplier).and_return(1.25)
        allow(@task).to receive(:apply_secondary_rate?).and_return(false)
        entry = CreateTimeEntry.call(@params).time_entry

        expect(entry.rate).to eq(12.5)
      end

      it "should set the rate to the users rate * holiday mutlipler if the task uses secondary rate but the user doesn't have one" do
        @task = create :task, apply_secondary_rate: true
        set_params
        allow(@user).to receive(:secondary_rate).and_return(nil)
        entry = CreateTimeEntry.call(@params).time_entry

        expect(entry.rate).to eq(20)
      end

      it "should set the rate to the users secondary_rate * holiday mutlipler if the task uses secondary rate" do
        @task = create :task, apply_secondary_rate: true
        set_params
        allow(@user).to receive(:secondary_rate).and_return(20)
        entry = CreateTimeEntry.call(@params).time_entry

        expect(entry.rate).to eq(40)
      end

      it "should set properly account for un-even numbers" do
        @task = create :task, apply_secondary_rate: true
        set_params
        allow(@user).to receive(:secondary_rate).and_return(5.25)
        entry = CreateTimeEntry.call(@params).time_entry

        expect(entry.rate).to eq(10.5)
      end
    end
  end

  it "should associate itself with a statement if there is one in its date range that is editable" do
    statement = create :statement, from: 1.week.ago, to: 1.day.from_now, user: @user
    allow(@user).to receive(:hourly?).and_return(true)
    entry = CreateTimeEntry.call(@params).time_entry

    expect(entry.statements).to include(statement)
  end

  it "should not associate itself with a statement if none exist in that date range" do
    expect(@time_entry.statements.blank?).to eq(true)
  end

  it "should not associate itself with a statement that is not in its date range" do
    create :statement, from: 1.week.ago, to: 2.days.ago, user: @user
    entry = CreateTimeEntry.call(@params).time_entry

    expect(entry.statements.blank?).to eq(true)
  end

  it "should associate itself with a statement that has to date after the entries date" do
    statement = create :statement, from: 1.day.from_now, to: 2.weeks.from_now, user: @user
    entry = CreateTimeEntry.call(@params).time_entry

    expect(entry.statements).to include(statement)
  end

  it "should not associate itself with a statement that is locked" do
    statement = create :statement, from: 1.week.ago, to: 1.day.from_now, user: @user
    statement.transition_to(:locked)

    allow(@user).to receive(:hourly?).and_return(true)
    entry = CreateTimeEntry.call(@params).time_entry

    expect(entry.statements.blank?).to eq(true)
  end
end
