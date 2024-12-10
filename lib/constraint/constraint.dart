enum MyWorkspaceRole {
  owner,
  member,
}

enum MyTaskState {
  pending,
  inProgress,
  completed,
  overDue,
}

Map myDateTimeException = {
  0: "date time was not set",
  1: "select time less than current time",
  2: "due must be greater than start time"
};
