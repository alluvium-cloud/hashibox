plan client::wipe (TargetSpec $targets) {

  # Wipe
  run_task('consul::wipe', $targets)
  run_task('nomad::wipe', $targets)
  run_task('vault::wipe', $targets)

}
