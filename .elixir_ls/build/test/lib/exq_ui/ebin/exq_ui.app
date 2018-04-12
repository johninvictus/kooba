{application,exq_ui,
             [{description,"Exq UI is the UI component for Exq, a job processing library.  Exq UI provides the UI dashboard\nto display stats on job processing.\n"},
              {modules,['Elixir.ExqUi','Elixir.ExqUi.RouterPlug',
                        'Elixir.ExqUi.RouterPlug.Router','Elixir.JsonApi',
                        'Elixir.LongWorker','Elixir.Mix.Tasks.Exq.Ui']},
              {registered,[]},
              {vsn,"0.9.0"},
              {mod,{'Elixir.ExqUi',[]}},
              {applications,[kernel,stdlib,elixir,logger,redix]}]}.
