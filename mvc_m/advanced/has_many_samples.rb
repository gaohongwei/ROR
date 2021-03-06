2. has_many through sample,  source
  has_many :owned_groups, class_name: 'Group'
  has_many :joined_groups, -> { where(user_groups: { status: 3 }) },   through: :user_groups, source: :group
  has_many :applied_groups, -> { where(user_groups: { status: 1 }) },  through: :user_groups, source: :group
  has_many :accepted_groups, -> { where(user_groups: { status: 2 }) }, through: :user_groups, source: :group
  has_many :approved_groups, -> { where(user_groups: { status: 2 }) }, through: :user_groups, source: :group
3. has_many through sample
  rails g scaffold disease name:string
  rails g scaffold symptom name:string
  rails g scaffold disease_symptom disease_id:integer symptom_id:integer --skip-controller

  class Symptom < ActiveRecord::Base
    has_many :disease_symptoms
    has_many :diseases, :through => :disease_symptoms
  end

  class Disease < ActiveRecord::Base
    has_many :disease_symptoms
    has_many :symptoms, :through => :disease_symptoms
  end

  class DiseaseSymptom < ActiveRecord::Base
    belongs_to :disease
    belongs_to :symptom
  end

<%= semantic_form_for @disease do |f| %>
  <%= f.inputs do %>
    <%= f.input :name %>
    <%= f.input :symptoms, :as => :check_boxes, :required => false %>
<%= f.actions %>
  <% end %>
<% end %>
======== Sample 1 ========  
class MlMethod 
  has_many :parameters, foreign_key: :method_id, class_name: 'MethodParameter'
end 
rails method MethodParameter method_id:integer  
======== Sample 2 ========
rails g model group name:string parent_id:integer

class Employee < ActiveRecord::Base
#rails g  model employee name:string mgr_id:integer
  belongs_to :boss, foreign_key: :mgr_id, class_name: 'EmployeeA'
  has_many   :subs, foreign_key: :mgr_id, class_name: 'EmployeeB'
end
For boss
select EmployeeA.* from EmployeeA where EmployeeA.id = employee.mgr_id
For sub
select EmployeeB.* from EmployeeB where EmployeeB.mgr_id = employee.id

======== Child table, belongs_to ========
Can have a belongs_to association
Need a foreign_key
belongs_to :parent, foreign_key: :parent_id, class_name: 'Group'

======== has_many ========
has_many/has_one/belongs_to
Rails assumes that the column used to hold the foreign key on the other model is 
the name of this model with the suffix _id added. 
If not, you need specify class_name

======== :primary_key ========
Haven't found use case yet
By convention, Rails assumes that the column used to hold the primary key of the association is id. 
You can override this and explicitly specify the primary key with the :primary_key option.

Self Joins
class Employee < ActiveRecord::Base
#rails g  model employee name:string mgr_id:integer
  belongs_to :boss, foreign_key: :mgr_id, class_name: 'Book'
  has_many   :subs, foreign_key: :mgr_id, class_name: 'Book'
end
class Employee < ActiveRecord::Base
  has_many :subordinates, class_name: "Employee",
                          foreign_key: "manager_id"
 
  belongs_to :manager, class_name: "Employee"
end


http://guides.rubyonrails.org/association_basics.html

---------- :source ----------
class User
  has_many :subscriptions
  has_many :newsletters, :through => :subscriptions
end

class Newsletter
  has_many :subscriptions
  has_many :users, :through => :subscriptions
  # Rename to subscribers
  has_many :subscribers, :through => :subscriptions, :source => :user  
end

# user_id, newsletter_id
class Subscription
  belongs_to :newsletter
  belongs_to :user
end
With this code, you can do something like 
Newsletter.find(id).users to 
get a list of the newsletter's subscribers. 

But if you want to be clearer and be able to type 
Newsletter.find(id).subscribers instead, 
you must change the Newsletter class to this:

You are renaming the users association to subscribers. 
If you don't provide the :source, Rails will look for an association 
called subscriber in the Subscription class. 
You have to tell it to use the user association 
in the Subscription class to make the list of subscribers.
