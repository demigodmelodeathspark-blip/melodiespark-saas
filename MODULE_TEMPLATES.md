# WPF Module Templates

## Quick Start Template - WalletModule.cs

```csharp
using System;
using System.Windows;
using Serilog;

namespace Melodiespark.Modules
{
    /// <summary>
    /// Wallet Module - Manages digital wallets and transactions
    /// </summary>
    public class WalletModule : IModule
    {
        private readonly ILogger _logger = Log.ForContext<WalletModule>();
        private decimal _balance = 1000.00m;

        public string Name => "Wallet";
        public string Description => "Digital wallet management";
        public Version Version => new Version("0.1.0");

        public void Initialize()
        {
            _logger.Information("Initializing Wallet Module");
            LoadWalletData();
        }

        public void Execute()
        {
            _logger.Debug("Executing Wallet operations");
            UpdateBalance();
            RefreshUI();
        }

        public void Shutdown()
        {
            _logger.Information("Shutting down Wallet Module");
            SaveWalletData();
        }

        private void LoadWalletData()
        {
            _logger.Debug("Loading wallet data from storage");
            // Load from database or file
        }

        private void UpdateBalance()
        {
            _logger.Debug("Updating wallet balance");
            // Update balance from API
        }

        private void SaveWalletData()
        {
            _logger.Debug("Saving wallet data");
            // Save to database or file
        }

        private void RefreshUI()
        {
            _logger.Debug("Refreshing wallet UI");
            // Update UI elements
        }
    }
}
```

## IModule Interface

```csharp
using System;

namespace Melodiespark.Modules
{
    public interface IModule
    {
        string Name { get; }
        string Description { get; }
        Version Version { get; }

        void Initialize();
        void Execute();
        void Shutdown();
    }
}
```

## Module Service

```csharp
using System;
using System.Collections.Generic;
using Serilog;

namespace Melodiespark.Services
{
    public class ModuleService
    {
        private readonly ILogger _logger = Log.ForContext<ModuleService>();
        private readonly Dictionary<string, IModule> _modules = new();

        public void RegisterModule(IModule module)
        {
            _modules[module.Name] = module;
            _logger.Information("Registered module: {ModuleName}", module.Name);
        }

        public void InitializeAll()
        {
            _logger.Information("Initializing all modules");
            foreach (var module in _modules.Values)
            {
                try
                {
                    module.Initialize();
                    _logger.Information("Module {ModuleName} initialized", module.Name);
                }
                catch (Exception ex)
                {
                    _logger.Error(ex, "Error initializing module {ModuleName}", module.Name);
                }
            }
        }

        public void ShutdownAll()
        {
            _logger.Information("Shutting down all modules");
            foreach (var module in _modules.Values)
            {
                try
                {
                    module.Shutdown();
                    _logger.Information("Module {ModuleName} shutdown", module.Name);
                }
                catch (Exception ex)
                {
                    _logger.Error(ex, "Error shutting down module {ModuleName}", module.Name);
                }
            }
        }
    }
}
```

## ViewModel Base Class

```csharp
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace Melodiespark.ViewModels
{
    public abstract class ViewModelBase : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }

        protected bool SetProperty<T>(ref T storage, T value, [CallerMemberName] string propertyName = null)
        {
            if (Equals(storage, value))
                return false;

            storage = value;
            OnPropertyChanged(propertyName);
            return true;
        }
    }
}
```

## Module Models

```csharp
using System;

namespace Melodiespark.Models
{
    public class Transaction
    {
        public string Id { get; set; }
        public decimal Amount { get; set; }
        public string Type { get; set; } // Debit, Credit
        public DateTime Timestamp { get; set; }
        public string Description { get; set; }
        public string Status { get; set; } // Pending, Completed, Failed
    }

    public class Wallet
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public decimal Balance { get; set; }
        public string Currency { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
```

---

Use these templates as starting points for extending the Melodiespark Engine!
