# Library functions

# Avalon streaming to left/right conversion

- `ast2lr.vhd`: Converts Avalon streaming (data-channel-valid) signals into left/right channels
- `lr2ast.vhd`: Converts left/right channels into an Avalon streaming protocol

# Fixed-point conversion functions

- `fp_conversions.h`: Converts fixed-point numbers to strings and vice versa

## Usage

### fp_to_str
Turns a uint32_t interpreted as a fixed point into a string.

`int fp_to_str(char * buf, uint32_t fp_num, size_t fractional_bits, bool is_signed)`

- `buf`: buffer in which to fill the string. It is assumed to have enough space. 

- `fp_num`: the uint32_t to be interpreted as a fixed point to be translated into a string

- `fractional_bits`: the number of fractional bits for the interpretation. No consideration is made to check that it is a sensible number. i.e. less than 32, more than 0.

- `is_signed`: whether or not to interpret the first bit as a sign. If true, the first bit is inspected then dumped.

- returns the length of the buffered string.

**Example**:
```c
/**
 * wet_dry_mix_show() - Return the wet_dry_mix value to user-space via sysfs.
 * @dev: Device structure for the comb filter. This device struct is embedded in
 *       the comb filter's platform device struct.
 * @attr: Unused.
 * @buf: Buffer that gets returned to the comb filter value to user-space.
 *
 * Return: The number of bytes read.
 */
static ssize_t wet_dry_mix_show(struct device *dev,
	struct device_attribute *attr, char *buf)
{
	/*
	 * wet_dry_mix is a u32 because that's what fp_to_str expects; its actual
	 * type is u16.16
	 */
	u32 wet_dry_mix;
	struct comb_filter_dev *priv = dev_get_drvdata(dev);

	wet_dry_mix = ioread32(priv->base_addr + WET_DRY_MIX_OFFSET);

	return fp_to_str(buf, wet_dry_mix, WET_DRY_MIX_FRAC_BITS, WET_DRY_MIX_SIGNED);
}
```

### str_to_fp
Converts a given string to a uint32_t interpreted as a fixed point.

`uint32_t str_to_fp(const char * s, int num_fractional_bits, bool is_signed, size_t size)`

- `s`, the string to be converted.

- `num_fractional_bits`, the number of fractional bits in the fixed point. No consideration is made to validate.

- `is_signed`, whether or not to interpret the string as a signed or not.

- `size`, the size of buffer that sysfs sent to us

- returns a uint32_t that is a fixed point representation based on the `num_fractional_bits` and `is_signed` params.

**Example**:
```c
/**
 * wet_dry_mix_store() - Store the wet_dry_mix value.
 * @dev: Device structure for the comb filter. This device struct is embedded in
 *       the comb filter's platform device struct.
 * @attr: Unused.
 * @buf: Buffer that contains the comb filter value being written.
 * @size: The number of bytes being written.
 *
 * Return: The number of bytes stored.
 */
static ssize_t wet_dry_mix_store(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t size)
{
	u32 wet_dry_mix;
	struct comb_filter_dev *priv = dev_get_drvdata(dev);

	wet_dry_mix = str_to_fp(buf, WET_DRY_MIX_FRAC_BITS, WET_DRY_MIX_SIGNED, size);

	iowrite32(wet_dry_mix, priv->base_addr + WET_DRY_MIX_OFFSET);

	// Write was successful, so we return the number of bytes we wrote.
	return size;
}
```