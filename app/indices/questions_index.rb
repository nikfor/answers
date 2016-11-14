ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title
  indexes body
  indexes user.email, as: :author_email, sortable: true

  has user_id, created_at, updated_at
end
