-- Legacy lazy.nvim plugin spec archived during vim.pack migration. This file no longer works as-is.
return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',

        -- Python adapter for pytest/unittest
        'nvim-neotest/neotest-python',
    },
    keys = {
        -- Keybindings as requested
        {
            '<leader>Tr',
            function()
                require('neotest').run.run()
            end,
            desc = '[T]est [R]un Nearest',
        },
        {
            '<leader>Tf',
            function()
                require('neotest').run.run(vim.fn.expand '%')
            end,
            desc = '[T]est Run [F]ile',
        },
        {
            '<leader>Td',
            function()
                -- Use dap-python directly instead of neotest's DAP strategy
                require('dap-python').test_method()
            end,
            desc = '[T]est [D]ebug Nearest',
        },
        {
            '<leader>Ts',
            function()
                require('neotest').summary.toggle()
            end,
            desc = '[T]est [S]ummary Toggle',
        },
        {
            '<leader>To',
            function()
                require('neotest').output.open { enter = true }
            end,
            desc = '[T]est [O]pen Output',
        },
        {
            '<leader>TO',
            function()
                require('neotest').output_panel.toggle()
            end,
            desc = '[T]est [O]utput Panel Toggle',
        },
        {
            '<leader>TS',
            function()
                require('neotest').run.stop()
            end,
            desc = '[T]est [S]top',
        },
    },
    config = function()
        -- Custom DAP strategy for neotest to fix path issues
        local neotest = require 'neotest'
        neotest.setup {
            adapters = {
                -- Python adapter - minimal configuration, let it use DAP defaults
                require('neotest-python') {
                    -- Use your ~/.venv Python which has both pytest and debugpy installed
                    python = vim.fn.expand '~/.venv/bin/python',
                    -- Test runner
                    runner = 'pytest',
                    -- Simple args
                    args = { '-vv', '-s' },
                },
            },

            -- Discovery options
            discovery = {
                enabled = true,
                concurrent = 8,
            },

            -- Diagnostic display
            diagnostic = {
                enabled = true,
                severity = vim.diagnostic.severity.ERROR,
            },

            -- Floating window options
            floating = {
                border = 'rounded',
                max_height = 0.8,
                max_width = 0.9,
            },

            -- Icons (works with your nerd font setting)
            icons = {
                passed = '✓',
                running = '●',
                failed = '✗',
                skipped = '○',
                unknown = '?',
                non_collapsible = '─',
                collapsed = '─',
                expanded = '╮',
                child_prefix = '├',
                final_child_prefix = '╰',
                child_indent = '│',
                final_child_indent = ' ',
            },

            -- Output options
            output = {
                enabled = true,
                open_on_run = false, -- Don't auto-open output window
            },

            -- Status display
            status = {
                enabled = true,
                virtual_text = false, -- Disable virtual text to avoid clutter
                signs = true,
            },

            -- Summary window
            summary = {
                enabled = true,
                expand_errors = true,
                follow = true,
                mappings = {
                    attach = 'a',
                    expand = { '<CR>', '<2-LeftMouse>' },
                    expand_all = 'e',
                    jumpto = 'i',
                    output = 'o',
                    run = 'r',
                    short = 'O',
                    stop = 'u',
                    watch = 'w',
                    -- debug = 'd', -- Disabled: neotest's DAP strategy has buffer/path issues
                    -- Use 'i' to jump to test file, then <leader>Td to debug instead
                },
            },

            -- Watch mode options
            watch = {
                enabled = true,
            },
        }
    end,
}
