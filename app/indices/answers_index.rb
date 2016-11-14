ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body
  indexes user.email, as: :author_email, sortable: true
  indexes comments.body, as: :answer_comment

  has user_id, created_at, updated_at
end
