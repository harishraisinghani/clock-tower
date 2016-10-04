describe TimeEntry do
  before :each do
    @time_entry = build(:time_entry)
  end

  after :all do
    TimeEntry.destroy_all
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:time_entry)).to be_valid
    end

    it "is valid without comments" do
      expect(build(:time_entry, comments: nil)).to be_valid
    end

    it "is invalid with a comment of over 255 characters" do
      long_comment = 'a' * 300
      expect(build(:time_entry, comments: long_comment)).to have(1).errors_on(:comments)
    end

    it "is invalid without an entry date" do
      expect(build(:time_entry, entry_date: nil)).to have(1).errors_on(:entry_date)
    end

    it "is invalid without a duration" do
      expect(build(:time_entry, duration_in_hours: nil).errors_on(:duration_in_hours).size).to eq(1)
    end

    it "is invalid without a user" do
      expect(build(:time_entry, user: nil)).to have(1).errors_on(:user)
    end

    it "is invalid without a project" do
      expect(build(:time_entry, project: nil)).to have(1).errors_on(:project)
    end

    it "is invalid without a task" do
      expect(build(:time_entry, task: nil)).to have(1).errors_on(:task)
    end

  end

  it "should not be editable on a locked statement" do
    entry = create :time_entry
    statement = create :statement
    entry.statements << statement
    statement.transition_to :locked

    expect(entry).to have(1).errors_on(:statement)
  end

  describe "#as_json" do
    it "should include id" do
      expect(@time_entry.as_json(root: false)[:id]).to eq(@time_entry.id)
    end

    it "should include user" do
      expect(@time_entry.as_json(root: false)[:user]).to_not be_nil
    end

    it "should include project" do
      expect(@time_entry.as_json(root: false)[:project]).to_not be_nil
    end

    it "should include taskb" do
      expect(@time_entry.as_json(root: false)[:task]).to_not be_nil
    end

    it "should include date" do
      expect(@time_entry.as_json(root: false)[:date]).to eq(@time_entry.entry_date)
    end

    it "should include duration" do
      expect(@time_entry.as_json(root: false)[:duration_in_hours]).to eq(@time_entry.duration_in_hours)
    end

    it "should include comments" do
      expect(@time_entry.as_json(root: false)[:comments]).to eq(@time_entry.comments)
    end
  end

  describe "#to_csv" do
    before :each do
      @te1 = create(:time_entry)
      @te1.user.location = create(:location)
      @te1.user.save
      @time_entries = TimeEntry.where(id: @te1.id)
    end

    it "should have headers" do
      expect(@time_entries.to_csv).to include("id,firstname,lastname,email,location,project,task,entry_date,duration_in_hours,rate\n")
    end

    # HACK some very loose tests here

    it "should contain user.id" do
      expect(@time_entries.to_csv).to include(@te1.user.id.to_s)
    end

    it "should contain firstname" do
      expect(@time_entries.to_csv).to include(@te1.user.firstname)
    end

    it "should contain lastname" do
      expect(@time_entries.to_csv).to include(@te1.user.lastname)
    end

    it "should contain email" do
      expect(@time_entries.to_csv).to include(@te1.user.email)
    end

    it "should contain user.location" do
      expect(@time_entries.to_csv).to include(@te1.user.location.name)
    end

    it "should contain project.name" do
      expect(@time_entries.to_csv).to include(@te1.project.name)
    end

    it "should contain task.name" do
      expect(@time_entries.to_csv).to include(@te1.task.name)
    end

    it "should contain entry_date" do
      expect(@time_entries.to_csv).to include(@te1.entry_date.to_s)
    end

    it "should contain duration_in_hours" do
      expect(@time_entries.to_csv).to include(@te1.duration_in_hours.to_s)
    end

    it "should contain rate" do
      expect(@time_entries.to_csv).to include(@te1.rate.to_s)
    end

  end

end
