namespace OrderAccumulator.Services;

public class ExposureCalculator
{
    private const decimal Limit = 100_000_000m;
    private readonly Dictionary<string, decimal> _exposures = new();
    private readonly object _lock = new();

    public (bool Accepted, decimal CurrentExposure) TryAcceptOrder(string symbol, char side, decimal price, int quantity)
    {
        lock (_lock)
        {
            if (!_exposures.TryGetValue(symbol, out var current))
                _exposures[symbol] = 0;

            var signedContribution = side == '1' ? price * quantity : -(price * quantity);
            var updated = _exposures[symbol] + signedContribution;

            if (Math.Abs(updated) > Limit)
                return (false, _exposures[symbol]);

            _exposures[symbol] = updated;
            return (true, updated);
        }
    }

    public IReadOnlyDictionary<string, decimal> GetExposures()
    {
        lock (_lock)
        {
            return new Dictionary<string, decimal>(_exposures);
        }
    }
}
